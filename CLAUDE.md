# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Java Servlet + JSP web application for a campus second-hand / B2B2C marketplace
("campus_secondhand"). It is a plain IntelliJ IDEA web module — there is **no Maven,
Gradle, or any build script**. Comments and UI strings are in Chinese.

- Servlet API: **Jakarta** namespace (`jakarta.servlet.*`), runs on **Tomcat 11.0.20**.
- DB: **MySQL** via JDBC (`mysql-connector-j-9.5.0.jar` in `web/WEB-INF/lib`).
- No test suite, no linter config.

## Build & run

There is no command-line build. Development is done in **IntelliJ IDEA** with a
Tomcat 11 run configuration deploying the `web/` exploded artifact
(see `bigwork.iml` / `.idea/artifacts/`). Compiled classes go to `web/WEB-INF/classes`.

Tomcat is expected at `../../../apache-tomcat-11.0.20/` relative to the module
(its `lib/servlet-api.jar` is the only provided servlet dependency).

To compile from the shell without the IDE (Git Bash, paths relative to repo root):

```bash
javac -encoding UTF-8 \
  -cp "../../../apache-tomcat-11.0.20/lib/servlet-api.jar;web/WEB-INF/lib/mysql-connector-j-9.5.0.jar" \
  -d web/WEB-INF/classes \
  $(find src -name '*.java')
```

### Database prerequisite

A MySQL instance must be running on `localhost:3306` with a `campus_secondhand`
schema. Connection settings (URL, user, **hardcoded password**) live in
`src/util/DBcon.java` — there is no external config file, so change them there.
There is no committed `.sql` schema; tables (`user`, `item`, `item_image`,
`product`, `order`/order table, `review`) must already exist.

## Architecture

Classic hand-rolled MVC, one layer per package under `src/`:

- **`servlet/`** — controllers, mapped with `@WebServlet` annotations (`web.xml` is
  empty). Each servlet reads request params, performs its own session-based auth
  check, calls a DAO, then either **writes an inline `<script>alert(...);
  location.href=...</script>` response** (the dominant pattern for actions/redirects)
  or **forwards to a JSP** via `RequestDispatcher` (used for page rendering, e.g.
  `IndexServlet` → `index.jsp`).
- **`dao/`** — JDBC data access. Every method news up a `DBcon`, opens a
  `Connection` in try-with-resources, uses `PreparedStatement`, and swallows
  exceptions with `printStackTrace()`. No connection pooling; one connection per call.
- **`bean/`** — plain JavaBeans (`User`, `Product`, `OrderVO`, `Review`,
  `ItemImage`) used as both model and view objects.
- **`util/`** — `DBcon` (JDBC factory) and `ImageServlet` (generates a captcha image
  and stores the answer in session under `piccode`).
- **`web/`** — JSPs (the views) plus `WEB-INF/`. JSPs pull data from request
  attributes set by servlets.

### Two coexisting domain models (important)

`ProductDao` contains **two parallel feature sets** that map to different tables —
don't confuse them:

- **Legacy C2C "item" model**: tables `item` / `item_image`, methods like
  `insertItemAndGetId`, `getAllActiveItems`, `getItemById`, status values
  `active`/`sold`/`off`. Multi-image via `item_image.sort_no`.
- **Current B2B2C "product" model**: tables `product` / `order` / `review`, methods
  like `addProduct`, `getAllOnSaleProducts`, `getProductsByMerchant`, status values
  `on_sale`/`off_sale`. Each product carries a `merchant_id`; ratings are denormalized
  onto `product.rating`/`review_count` and recomputed by `updateProductRating`.

New work is on the **product** model. The order/buy/review flow
(`BuyServlet`, `OrderDao`, `SubmitReviewServlet`, ship/confirm servlets) is
product-based.

### Auth & roles

No framework/filter for security. Login (`LoginServlet`) validates a captcha
(`piccode` from session) then stores `userId`, `userName`, `userRole` in the
`HttpSession`. Three roles drive routing and per-servlet guards: **`admin`**,
**`merchant`**, **`customer`**. A user's `userId` *is* their `merchantId`.
Each protected servlet re-checks `session.getAttribute("userRole")` itself
(e.g. `MerchantAddProductServlet` rejects non-merchants).

### Image uploads

`MerchantAddProductServlet` uses `@MultipartConfig` and writes uploaded files
(UUID-named) to `getServletContext().getRealPath("/") + "images/products"` —
i.e. into the **deployed** webapp dir, not the source tree. Only `main_image`
(a filename string) is stored in the DB.

## Conventions to follow

- Keep the existing layering: servlet → DAO → `DBcon`; never put SQL in servlets/JSPs.
- DAO methods follow the try-with-resources + `PreparedStatement` pattern already in
  `UserDao`/`ProductDao` (with `?` placeholders — preserve this, do not string-concat
  user input into SQL).
- Set `request.setCharacterEncoding("UTF-8")` and the UTF-8 content type at the top of
  servlets, as existing ones do, to keep Chinese text from corrupting.

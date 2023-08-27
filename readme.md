<div align=center>

# ShopifyExtractor

#### Shopify ecommerces data in a instant

**[About](#about)** - [License](#license)

</div>

## About

This library scrapes Shopify stores to you use for the way you want!

## Features

### Product extraction

Just provide a product URL, it will return a `ShopifyProduct` object

**Usage**
```nim
let products = getAllShopifyProductUrls "https://arandomshopify.shop"

for productUrl in products:
  let product = extractShopifyProduct productUrl
  echo product[]
```

## License

This scraper library is another contribution to open source community, licensed
over GPL-3 license!

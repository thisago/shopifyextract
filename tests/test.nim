import std/asyncdispatch
import std/unittest

import shopifyextractor

var productUrl: string

suite "Shopifyextractor":
  test "Extract pages":
    let products = waitFor getAllShopifyProductUrls "https://lojaprecohonesto.com.br"
    require products.len > 50
    productUrl = products[0]
  test "Extract product":
    let product = waitFor extractShopifyProduct productUrl
    require product.url.len > 0
    require product.title.len > 0
    require product.price > 0
    require product.images.len > 0

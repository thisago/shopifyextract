import std/asyncdispatch
from std/uri import parseUri, `$`
from std/htmlparser import parseHtml
from std/strutils import contains
from std/xmltree import XmlNode, innerText, child

import pkg/nimquery

import pkg/unifetch

import shopifyextractor/product
export product
import shopifyextractor/types
export types

proc fetchSitemap(url: Uri or string): Future[XmlNode] {.async.} =
  let
    uni = newUniClient()
    resp = await uni.get url
  close uni
  result = parseHtml resp.body

proc getAllShopifyProductUrls*(url: string): Future[seq[string]] {.async.} =
  ## Returns all products of a Shopify ecommerce
  var smUrl = parseUri url
  smUrl.path = "sitemap.xml"
  smUrl.query = ""
  
  for sitemap in (await fetchSitemap smUrl).querySelectorAll "sitemap":
    let smSmUrl = sitemap.child("loc").innerText
    if "products" in smSmUrl:
      for url in (await fetchSitemap smSmUrl).querySelectorAll "url":
        let productUrl = parseUri url.child("loc").innerText
        if productUrl.path.len > 5 and "product" in productUrl.path:
          result.add $productUrl
  
when isMainModule:
  echo waitFor getAllShopifyProductUrls "https://lojaprecohonesto.com.br/products/camisa-sao-paulo-away-2023"

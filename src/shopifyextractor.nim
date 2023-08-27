import std/asyncdispatch
from std/uri import parseUri, `$`
from std/htmlparser import parseHtml
from std/strutils import contains
# from std/xmltree import XmlNode, innerText, xnElement
import std/xmltree 

import pkg/nimquery

import pkg/unifetch

import shopifyextractor/types
import shopifyextractor/product
export product

proc fetchSitemap(url: Uri or string): Future[XmlNode] {.async.} =
  let
    uni = newUniClient()
    resp = await uni.get url
  close uni
  result = parseHtml resp.body

proc getAllProducts(url: string): Future[seq[string]] {.async.} =
  ## Returns all products of a Shopify ecommerce
  var smUrl = parseUri url
  smUrl.path = "sitemap.xml"
  smUrl.query = ""
  
  for sitemap in (await fetchSitemap smUrl).querySelectorAll "sitemap":
    let smSmUrl = sitemap.child("loc").innerText
    if "products" in smSmUrl:
      for url in (await fetchSitemap smSmUrl).querySelectorAll "url":
        result.add url.child("loc").innerText
  
when isMainModule:
  echo len waitFor getAllProducts "https://lojaprecohonesto.com.br/products/camisa-sao-paulo-away-2023"

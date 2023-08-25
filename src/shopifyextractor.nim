import std/asyncdispatch
from std/uri import parseUri
from std/htmlparser import parseHtml
from std/strutils import contains
# from std/xmltree import XmlNode, innerText, xnElement
import std/xmltree 

import pkg/nimquery

import pkg/unifetch

import shopifyextractor/types

proc fetchSitemap(url: Uri or string): Future[XmlNode] {.async.} =
  let
    uni = newUniClient()
    resp = await uni.get url
  close uni
  result = parseHtml resp.body

proc extractShopify(url: string): Future[ShopifyEcommerce] {.async.} =
  ## Extracts all products of a Shopify ecommerce
  var smUrl = parseUri url
  smUrl.path = "sitemap.xml"
  
  for sitemap in (await fetchSitemap smUrl).querySelectorAll "sitemap":
    if not sitemap.isNil and sitemap.kind == xnElement:
      let smSmUrl = sitemap.child("loc").innerText
      echo smSmUrl
      # if "products" in smSmUrl:
      #   for url in (await fetchSitemap smSmUrl).querySelectorAll "url":
      #     if not url.isNil and url.kind == xnElement:
      #       echo url
      #   break
  
  
when isMainModule:
  echo waitFor(extractShopify "https://lojaprecohonesto.com.br/products/camisa-sao-paulo-away-2023")[]

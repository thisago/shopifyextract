import std/asyncdispatch
from std/htmlparser import parseHtml
from std/json import parseJson, `{}`, getStr, getInt, items
from std/xmltree import innerText, `$`

import pkg/nimquery

import pkg/unifetch

import ./types

proc extractShopifyProduct*(url: string): Future[ShopifyProduct] {.async.} =
  ## Extract product
  let
    uni = newUniClient()
    resp = await uni.get url
  close uni

  let
    html = parseHtml resp.body
    json = parseJson html.querySelector("script[data-product-json]").innerText
    product = json{"product"}

  new result
  result.url = url
  result.title = product{"title"}.getStr
  result.description = $html.querySelector(".product-block-list__item--description")
  result.price = product{"price"}.getInt / 100
  for media in product{"media"}:
    result.images.add "https:" & media{"src"}.getStr

when isMainModule:
  echo waitFor(extractShopifyProduct "https://lojaprecohonesto.com.br/products/camisa-sao-paulo-away-2023")[]

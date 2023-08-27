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
    scriptTag = html.querySelector("script[data-product-json]")

  if scriptTag.isNil:
    return

  let
    json = parseJson scriptTag.innerText
    product = json{"product"}

  new result
  result.url = url
  result.title = product{"title"}.getStr
  result.description = $html.querySelector(".product-block-list__item--description")
  result.price = product{"price"}.getInt / 100
  for media in product{"media"}:
    result.images.add "https:" & media{"src"}.getStr

when isMainModule:
  let product = waitFor extractShopifyProduct "https://lojaprecohonesto.com.br/"
  if not product.isNil:
    echo product[]
  else:
    echo "nil"

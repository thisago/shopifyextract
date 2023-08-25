type
  ShopifyEcommerce* = ref object
    url*: string
    name*: string
    products*: seq[string]
  ShopifyProduct* = ref object
    url*: string
    title*: string
    price*: float
    images*: seq[string]
    description*: string # Converted to markdown

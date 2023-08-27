type
  ShopifyProduct* = ref object
    url*: string
    title*: string
    price*: float
    images*: seq[string]
    description*: string # Converted to markdown

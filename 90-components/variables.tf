variable "components" {
  default = {
    catalogue = {
        rule_priority = 15
    }
    user = {
        rule_priority = 20
    }
    cart = {
        rule_priority = 30
    }
    shipping = {
        rule_priority = 40
    }
    payment = {
        rule_priority = 50
    }
    frontend = {
        rule_priority = 10   # (frontend rule is on a different listener, so 10 is ok here)
    }

  }
}
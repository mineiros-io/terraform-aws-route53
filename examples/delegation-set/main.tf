module "delegation-set" {
  source = "../.."

  create = false
  name   = null

  create_delegation_set = true
}

module "foo-com" {
  source = "../.."

  name              = "foo.com"
  delegation_set_id = module.delegation-set.delegation_set[0].id
}

module "bob-com" {
  source = "../.."

  name              = "bob.com"
  delegation_set_id = module.delegation-set.delegation_set[0].id
}

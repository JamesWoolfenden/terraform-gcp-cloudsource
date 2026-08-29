locals {
  iam_members = flatten([
    for role, members in var.iam_bindings : [
      for member in members : {
        role   = role
        member = member
      }
    ]
  ])

  subscription_count = var.create_subscription ? 1 : 0
}

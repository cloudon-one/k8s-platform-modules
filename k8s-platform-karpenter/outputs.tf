output "event_rules" {
  value = module.karpenter.event_rules
}

output "iam_role_arn" {
  value = module.karpenter.iam_role_arn 
}

output "service_account" {
  value = module.karpenter.service_account
}
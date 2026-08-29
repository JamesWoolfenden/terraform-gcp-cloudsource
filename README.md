# terraform-gcp-cloudsource

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-cloudsource/workflows/Verify/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-gcp-cloudsource)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-cloudsource.svg)](https://github.com/JamesWoolfenden/terraform-gcp-cloudsource/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-cloudsource.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-cloudsource/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.14.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![checkov](https://img.shields.io/badge/checkov-verified-brightgreen)](https://www.checkov.io/)

A working cloudsource module with example.

## Usage

Add **module.cloudsource.tf** to your code:-

```terraform
module "cloudsource" {
    source      ="jameswoolfenden/cloudsource/gcp"
    version     = "0.1.1"
    name        = "pike"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_pubsub_subscription.dead_letter](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_subscription.pike](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_subscription_iam_member.pike_subscriber](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription_iam_member) | resource |
| [google_pubsub_topic.dead_letter](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic.pike](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic_iam_member.dead_letter_publisher](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_pubsub_topic_iam_member.pike_publisher](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_service_account.pike](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_sourcerepo_repository.pike](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sourcerepo_repository) | resource |
| [google_sourcerepo_repository_iam_binding.readers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sourcerepo_repository_iam_binding) | resource |
| [google_sourcerepo_repository_iam_member.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sourcerepo_repository_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ack_deadline_seconds"></a> [ack\_deadline\_seconds](#input\_ack\_deadline\_seconds) | Seconds Pub/Sub waits for the subscriber to acknowledge a notification before redelivering it | `number` | `20` | no |
| <a name="input_create_subscription"></a> [create\_subscription](#input\_create\_subscription) | Create a pull subscription (plus a dead-letter topic and its own subscription) for the repository notification topic. Off by default: without a subscription every notification the repository emits is discarded, so enable this unless a consumer attaches its own subscription to the exported topic | `bool` | `false` | no |
| <a name="input_dead_letter_max_delivery_attempts"></a> [dead\_letter\_max\_delivery\_attempts](#input\_dead\_letter\_max\_delivery\_attempts) | Delivery attempts before a notification is forwarded to the dead-letter topic | `number` | `5` | no |
| <a name="input_iam_bindings"></a> [iam\_bindings](#input\_iam\_bindings) | Map of IAM role to list of members to grant on the Cloud Source Repository, e.g. { "roles/source.reader" = ["user:alice@example.com"] } | `map(list(string))` | n/a | yes |
| <a name="input_key"></a> [key](#input\_key) | Fully-qualified Cloud KMS crypto key ID used to encrypt the notification Pub/Sub topic, e.g. projects/p/locations/global/keyRings/r/cryptoKeys/k | `string` | n/a | yes |
| <a name="input_message_retention_duration"></a> [message\_retention\_duration](#input\_message\_retention\_duration) | How long the notification topic retains published messages for replay, as a duration in seconds (e.g. 604800s for 7 days, the Pub/Sub maximum) | `string` | `"604800s"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Cloud Source repository or resource | `string` | n/a | yes |
| <a name="input_pubsub_service_agent_email"></a> [pubsub\_service\_agent\_email](#input\_pubsub\_service\_agent\_email) | Email of the Pub/Sub service agent (service-PROJECT\_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com). Required when var.create\_subscription is true, so the agent can publish to the dead-letter topic and subscribe to the notification subscription | `string` | `null` | no |
| <a name="input_repository_readers"></a> [repository\_readers](#input\_repository\_readers) | Principals granted roles/source.reader on the repository, authoritatively for that role. Empty to create no binding | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_dead_letter_topic"></a> [dead\_letter\_topic](#output\_dead\_letter\_topic) | The dead-letter topic, or null when var.create\_subscription is false |
| <a name="output_repository"></a> [repository](#output\_repository) | The source repository |
| <a name="output_sa"></a> [sa](#output\_sa) | Details on the SA |
| <a name="output_subscription"></a> [subscription](#output\_subscription) | The notification subscription, or null when var.create\_subscription is false |
| <a name="output_topic"></a> [topic](#output\_topic) | Details of the Topic |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.update",
    "pubsub.subscriptions.create",
    "pubsub.subscriptions.delete",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.getIamPolicy",
    "pubsub.subscriptions.list",
    "pubsub.subscriptions.setIamPolicy",
    "pubsub.subscriptions.update",
    "pubsub.topics.attachSubscription",
    "pubsub.topics.create",
    "pubsub.topics.delete",
    "pubsub.topics.detachSubscription",
    "pubsub.topics.get",
    "pubsub.topics.getIamPolicy",
    "pubsub.topics.setIamPolicy",
    "pubsub.topics.update",
    "source.repos.create",
    "source.repos.delete",
    "source.repos.get",
    "source.repos.getIamPolicy",
    "source.repos.setIamPolicy",
    "source.repos.updateRepoConfig"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "iam.serviceAccounts.get",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.getIamPolicy",
    "pubsub.subscriptions.list",
    "pubsub.topics.get",
    "pubsub.topics.getIamPolicy",
    "source.repos.get",
    "source.repos.getIamPolicy"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Related Projects

Check out these related projects.

- [terraform-aws-codecommit](https://github.com/jameswoolfenden/terraform-aws-codebuild) - Storing ones code

## Help

**Got a question?**

File a GitHub [issue](https://github.com/jameswoolfenden/terraform-gcp-cloudsource/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/jameswoolfenden/terraform-gcp-cloudsource/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2019-2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150

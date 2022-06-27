# HashiCorp Vault & AWS - Dynamic Secrets

![FullStackS GmbH](https://static.wixstatic.com/media/09b67c_95629a63c35b44f581d199a824b2e99d~mv2.png/v1/fill/w_494,h_106,al_c,q_85,usm_0.66_1.00_0.01/Logo_final-01-removebg-preview.webp )

![Advanced Unibyte](https://www.au.de/typo3conf/ext/aus_project/Resources/Public/Images/logo.png)


![HashiCorp Vault](https://www.datocms-assets.com/2885/1620159869-brandvaultprimaryattributedcolor.svg )


## Einleitung

Dies ist ein kleines Mockup (Demo) der HashiCorp Vault Dynamic Secret Engine für AWS.
Auf dieser Basis können kurzlebige Zugangsdaten für Aktionen in der Cloud erstellt werden.
Selbes ist aber z.B. auch für Datenbanken möglich. 

Kurzum: 

Dynamische Zugangsdaten ermöglichen sehr einfach einen hohen Grad an Sicherheit. 
Zusätzlich können diese mit Policies und Identiy Providern sehr granular gesteuert werden.


Dieses Mockup basiert auf HashiCorp Terraform, dem de-facto Standard für Infrastructure as Code


## Nutzung Terraform Code

Sämtliche Variablen können entweder in einer `terraform.tfvars` oder aber als Environment Variable definiert werden.
(In diesem Mockup nutzen wir HashiCorp Terraform Cloud und den integrierten Vault für sensible Variablen).

```
export TF_VAR_aws_access_key=<KEY>

export TF_VAR_aws_secret_key=<KEY>

export TF_VAR_vault_address=https://vault.fullstacks.eu:8200


export TF_VAR_vault_token=<TOKEN>

```

### Was geschieht hinter den Kulissen? 

Terraform erzeugt in HashiCorp Vault ein neues Secret Backend "aws_secret".
Dieses nutzt vorhandene IAM Credentials für programmatischen Zugriff (AWS Keys).

Anschliessend wird eine Role, in diesem Fall für EC2 Vollzugriff erstellt.

(Virtuell ist hier jede AWS IAM Policy vorstellbar / implementierbar)

```

Terraform will perform the following actions:

  # vault_aws_secret_backend.aws_secret will be created
  + resource "vault_aws_secret_backend" "aws_secret" {
      + access_key                = (sensitive value)
      + default_lease_ttl_seconds = 60
      + id                        = (known after apply)
      + max_lease_ttl_seconds     = 120
      + path                      = "aws"
      + region                    = (known after apply)
      + secret_key                = (sensitive value)
      + username_template         = (known after apply)
    }

  # vault_aws_secret_backend_role.ec2_admin_role will be created
  + resource "vault_aws_secret_backend_role" "ec2_admin_role" {
      + backend         = "aws"
      + credential_type = "iam_user"
      + default_sts_ttl = (known after apply)
      + id              = (known after apply)
      + max_sts_ttl     = (known after apply)
      + name            = "ec2-admin-role"
      + policy_document = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ec2:*",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "*",
                        ]
                      + Sid      = "Stmt1426528957000"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

vault_aws_secret_backend.aws_secret: Creating...
vault_aws_secret_backend.aws_secret: Creation complete after 0s [id=aws]
vault_aws_secret_backend_role.ec2_admin_role: Creating...
vault_aws_secret_backend_role.ec2_admin_role: Creation complete after 0s [id=aws/roles/ec2-admin-role]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

```

## Verwendung von dynamischen Secrets

### Vault CLI

Über die Vault CLI können mit folgendem Kommando dynamische Secrets (sog. Leases) erzeugt werden:

`vault read aws/creds/ec2-admin-role`

Das Output sieht wie folgt aus:

```
/ $ vault read aws/creds/ec2-admin-role
Key                Value
---                -----
lease_id           aws/creds/ec2-admin-role/Ff7Ys8qLq4Rn3sAMmDHpM347
lease_duration     1m
lease_renewable    true
access_key         AKIAYW2QZCXARNNSFNZQ
secret_key         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
security_token     <nil>
```


### Vault User Interface

Auswahl der Secret Engine `aws` --> Klick auf "Rolle" --> "Generate" 


### Programmatisch via Terraform oder API (der goldene Weg)

https://registry.terraform.io/providers/hashicorp/vault/latest

https://www.vaultproject.io/api-docs

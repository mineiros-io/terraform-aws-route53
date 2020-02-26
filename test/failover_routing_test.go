package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestFailoverRouting(t *testing.T) {
	t.Parallel()

	expectedZoneName := getUniqueTestZoneName()

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/failover-routing",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"zone_name": expectedZoneName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

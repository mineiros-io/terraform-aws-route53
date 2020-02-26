package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMultipleDomainsSameRecords(t *testing.T) {
	t.Parallel()

	expectedZoneAName := getUniqueTestZoneName()
	expectedZoneBName := getUniqueTestZoneName()

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/multiple-domains-same-records",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"zone_a": expectedZoneAName,
			"zone_b": expectedZoneBName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

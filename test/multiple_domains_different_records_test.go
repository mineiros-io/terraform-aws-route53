package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMultipleDomainsDifferentRecords(t *testing.T) {
	t.Parallel()

	expectedZoneAName := strings.ToLower(fmt.Sprintf("mineiros-%s.io", random.UniqueId()))
	expectedZoneBName := strings.ToLower(fmt.Sprintf("mineiros-%s.io", random.UniqueId()))

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "./multiple-domains-different-records",
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

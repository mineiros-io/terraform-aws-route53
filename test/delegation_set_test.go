package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDelegationSet(t *testing.T) {
	t.Parallel()

	expectedMainZoneName := strings.ToLower(fmt.Sprintf("mineiros-%s.io", random.UniqueId()))
	expectedSecondaryZoneName := strings.ToLower(fmt.Sprintf("mineiros-%s.io", random.UniqueId()))

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "./delegation-set",
		Upgrade:      true,
		// Variables to pass to our Terraform module using -var options
		Vars: map[string]interface{}{
			"main_zone_name":      expectedMainZoneName,
			"secondary_zone_name": expectedSecondaryZoneName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

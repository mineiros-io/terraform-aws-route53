package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

//TestModuleEnabled : Tests that no resources are being created
// when `module_enabled` is set to `false`
func TestModuleEnabled(t *testing.T) {
	t.Parallel()

	// Receive a random region from the list of available regions of the account
	// that is associated to the credentials used for running this test
	randomAwsRegion := aws.GetRandomRegion(t, nil, nil)

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "./module-enabled",
		Vars: map[string]interface{}{
			"aws_region": randomAwsRegion,
		},
		Upgrade: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	stdout := terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	// Validate that Terraform didn't create, change or destroy any resources
	resourceCount := terraform.GetResourceCount(t, stdout)
	assert.Equal(t, 0, resourceCount.Add, "No resources should have been created. Found %d instead.", resourceCount.Add)
	assert.Equal(t, 0, resourceCount.Change, "No resources should have been changed. Found %d instead.", resourceCount.Change)
	assert.Equal(t, 0, resourceCount.Destroy, "No resources should have been destroyed. Found %d instead.", resourceCount.Destroy)
}

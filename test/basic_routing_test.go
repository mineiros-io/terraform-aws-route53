package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestBasicRouting(t *testing.T) {
	t.Parallel()

	expectedZoneName := strings.ToLower(fmt.Sprintf("mineiros-%s.io", random.UniqueId()))
	expectedDevTargets := []string{"172.217.16.111", "172.217.16.112"}

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/basic_routing",
		Upgrade:      true,

		// Variables to pass to our Terraform module using -var options
		Vars: map[string]interface{}{
			"zone_name":   expectedZoneName,
			"dev_targets": expectedDevTargets,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Retrieve the zone_name from the outputs
	zoneName := terraform.Output(t, terraformOptions, "zone_name")

	// Validate if the name of the created zone matches the name that we defined in zone_name
	assert.Equal(t, expectedZoneName+".", zoneName)

	// Validate that the length of the list of records
	expectedListLen := len(expectedDevTargets)
	outputList := terraform.OutputList(t, terraformOptions, "dev_targets")
	require.Len(t, outputList, expectedListLen, "Output list should contain %d items", expectedListLen)

	// Validate that the list of records matches the list of records passed as a Terraform variable
	require.Equal(t, expectedDevTargets, outputList)
}

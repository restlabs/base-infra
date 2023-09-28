package vpc

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTerraformBaseVpc(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		BackendConfig: map[string]interface{}{
			"bucket":         "pafable-tfstates-100",
			"key":            "vpc/base/terraform.tfstate",
			"region":         "us-east-1",
			"encrypt":        "true",
			"dynamodb_table": "terraform-lock",
		},
		Reconfigure: true,
		Vars: map[string]interface{}{
			"app_name":      "base-infra",
			"cidr_block":    "10.10.0.0/16",
			"code_location": "terraform/modules/vpc",
			"email":         "pafable@test.com",
			"environment":   "dev",
			"owner":         "pafable",
			"project":       "base-infra",
			"region":        "us-east-1",
		},
	})

	// destroy resources when test ends successfully or not
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// checks if dns support enabled
	outputIsDnsSupportEnabled := terraform.Output(t, terraformOptions, "vpc_is_dns_support_enabled")
	assert.Equal(t, "true", outputIsDnsSupportEnabled)
}

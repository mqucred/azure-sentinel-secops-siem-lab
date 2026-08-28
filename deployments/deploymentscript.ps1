# Define standard enterprise tags
$tags = @{
    Environment = "Production"
    Workload    = "SecOps-SIEM"
    ManagedBy   = "Cloud-Ops"
    CostCenter  = "Security"
}

# 1. Set context to your platform subscription
Set-AzContext -SubscriptionName "sub-ent-platform-prod"

# 2. Create dedicated SecOps Resource Group with Tags
New-AzResourceGroup `
  -Name "rg-secops-prod-01" `
  -Location "East US" `
  -Tag $tags

# 3. Provision Log Analytics Workspace (30-day retention + Tags)
New-AzOperationalInsightsWorkspace `
  -ResourceGroupName "rg-secops-prod-01" `
  -Name "law-secops-prod-01" `
  -Location "East US" `
  -Sku "pergb2018" `
  -RetentionInDays 30 `
  -Tag $tags

# 4. Enable Microsoft Sentinel Solution (Triggers 30-Day Free Trial)
New-AzOperationalInsightsIntelligencePack `
  -ResourceGroupName "rg-secops-prod-01" `
  -WorkspaceName "law-secops-prod-01" `
  -IntelligencePackName "SecurityInsights" `
  -Enabled $true

# 5. Set Strict Daily Data Ingestion Cap (1 GB/day Cost Guardrail)
Set-AzOperationalInsightsWorkspace `
  -ResourceGroupName "rg-secops-prod-01" `
  -Name "law-secops-prod-01" `
  -DailyQuotaGb 1

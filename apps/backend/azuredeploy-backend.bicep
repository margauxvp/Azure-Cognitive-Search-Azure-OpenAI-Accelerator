@description('Required. Active Directory App ID.')
param appId string = '2cdaac95-b3b5-4d3d-a06a-7629a3c88a9c'

@description('Required. Active Directory App Secret Value.')
@secure()
param appPassword string = 'leX8Q~igrJ3bJlp9VlvF.w7blxpnsgW91tyIVal1'

@description('Required. The SAS token for the Azure Storage Account hosting your data')
@secure()
param datasourceSASToken string = 'sp=r&st=2023-10-01T07:48:13Z&se=2023-10-01T15:48:13Z&spr=https&sv=2022-11-02&sr=c&sig=n8Y2eQGgkPEvu%2F7AG%2F0daphWHoIhHPIAl0DDKqatXNo%3D'

@description('Optional. The API version for the Azure Search service.')
param azureSearchAPIVersion string = '2023-07-01-Preview'

@description('Optional. The API version for the Azure Search service.')
param azureSearchKey string = 'w1xOCgXeL08HnDCdbKiKtiHakcd4FcZx3GzLkQTsorAzSeBILKNU'

@description('Required. The API key of the Azure OpenAI resource deployed previously.')
param azureOpenAIAPIKey string = '6c9c4a46f7944f86a3b92a48ea59c170'

@description('Optional. The model name for the Azure OpenAI service.')
param azureOpenAIModelName string = 'gpt-35-turbo-16k'

@description('Optional. The API version for the Azure OpenAI service.')
param azureOpenAIAPIVersion string = '2023-07-01-preview'

@description('Optional. The URL for the Bing Search service.')
param bingSearchUrl string = 'https://api.bing.microsoft.com'

@description('Required. The key the Bing Search service deployed previously.')
param bingSearchKey string = 'b216f8fef16845e4a672f016c9508bc6'

@description('Required. The name of the SQL server deployed previously.')
param SQLServerName string = 'dev-sql-ai-01'

@description('Required. The name of the SQL Server database.')
param SQLServerDatabase string = 'dev-sql-db-ai-01'

@description('Required. The name of the SQL Server Administrator.')
param SQLServerUserName string = 'devsqlaaidmin'

@description('Required. The password for the SQL Server.')
@secure()
param SQLServerPassword string = 'devSQLadmin!'

@description('Required. The name of the Azure CosmosDB.')
param cosmosDBAccountName string = 'dev-cosmos-db-ai-01'

@description('Required. The name of the Azure CosmosDB container.')
param cosmosDBContainerName string = 'dev-cosmos-ai-db-container-01'

@description('Optional. The globally unique and immutable bot ID. Also used to configure the displayName of the bot, which is mutable.')
param botId string = 'dev-bot-ai-01'

@description('Optional, defaults to F0. The pricing tier of the Bot Service Registration. Acceptable values are F0 and S1.')
@allowed([
  'F0'
  'S1'
])
param botSKU string = 'S1'

@description('Optional. The name of the new App Service Plan.')
param appServicePlanName string = 'dev-app-service-plan-ai-01'

@description('Optional, defaults to S3. The SKU of the App Service Plan. Acceptable values are B3, S3 and P2v3.')
@allowed([
  'B3'
  'S3'
  'P2v3'
])
param appServicePlanSKU string = 'S3'

@description('Optional, defaults to resource group location. The location of the resources.')
param location string = resourceGroup().location

var publishingUsername = '$${botId}'
var webAppName = 'webApp-Backend-${botId}'
var siteHost = '${webAppName}.azurewebsites.net'
var botEndpoint = 'https://${siteHost}/api/messages'

// Create a new Linux App Service Plan if no existing App Service Plan name was passed in.
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSKU
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// Create a Web App using a Linux App Service Plan.
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${webAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${webAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: appServicePlan.id
    reserved: true
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    hostNamesDisabled: false
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    siteConfig: {
      appSettings: [
        {
          name: 'MicrosoftAppId'
          value: appId
        }
        {
          name: 'MicrosoftAppPassword'
          value: appPassword
        }
        {
          name: 'DATASOURCE_SAS_TOKEN'
          value: datasourceSASToken
        }
        {
          name: 'AZURE_SEARCH_ENDPOINT'
          value: 'https://dev-search-ai-01.search.windows.net'
        }
        {
          name: 'AZURE_SEARCH_KEY'
          value: azureSearchKey
        }
        {
          name: 'AZURE_SEARCH_API_VERSION'
          value: azureSearchAPIVersion
        }
        {
          name: 'AZURE_OPENAI_ENDPOINT'
          value: 'https://dev-aoai-ai-01.openai.azure.com/'
        }
        {
          name: 'AZURE_OPENAI_API_KEY'
          value: azureOpenAIAPIKey
        }
        {
          name: 'AZURE_OPENAI_MODEL_NAME'
          value: azureOpenAIModelName
        }
        {
          name: 'AZURE_OPENAI_API_VERSION'
          value: azureOpenAIAPIVersion
        }
        {
          name: 'BING_SEARCH_URL'
          value: bingSearchUrl
        }
        {
          name: 'BING_SUBSCRIPTION_KEY'
          value: bingSearchKey
        }
        {
          name: 'SQL_SERVER_NAME'
          value: SQLServerName
        }
        {
          name: 'SQL_SERVER_DATABASE'
          value: SQLServerDatabase
        }
        {
          name: 'SQL_SERVER_USERNAME'
          value: SQLServerUserName
        }
        {
          name: 'SQL_SERVER_PASSWORD'
          value: SQLServerPassword
        }
        {
          name: 'AZURE_COSMOSDB_ENDPOINT'
          value: 'https://${cosmosDBAccountName}.documents.azure.com:443/'
        }
        {
          name: 'AZURE_COSMOSDB_NAME'
          value: cosmosDBAccountName
        }
        {
          name: 'AZURE_COSMOSDB_CONTAINER_NAME'
          value: cosmosDBContainerName
        }
        {
          name: 'AZURE_COMOSDB_CONNECTION_STRING'
          value: 'AccountEndpoint=https://dev-cosmos-db-acc-ai-01.documents.azure.com:443/;AccountKey=6ef6RiMULX2OvPKMZH9ps8b9RFSkS7e5Z1y4zdkVQXKTDtwifZlAg9k1CI8EloslxtU1VF1d28hCACDbCg8V6A==;'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://botservice.hosting.portal.azure.net'
          'https://hosting.onecloud.azure-test.net/'
        ]
      }
    }
  }
}

resource webAppConfig 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: webApp
  name: 'web'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    phpVersion: ''
    pythonVersion: ''
    nodeVersion: ''
    linuxFxVersion: 'PYTHON|3.10'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2017'
    httpLoggingEnabled: true
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: publishingUsername
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: true
    appCommandLine: 'gunicorn --bind 0.0.0.0 --worker-class aiohttp.worker.GunicornWebWorker --timeout 600 app:APP'
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
        virtualDirectories: null
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetName: ''
    minTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
  }
}

resource bot 'Microsoft.BotService/botServices@2022-09-15' = {
  name: botId
  location: 'global'
  kind: 'azurebot'
  sku: {
    name: botSKU
  }
  properties: {
    displayName: botId
    iconUrl: 'https://docs.botframework.com/static/devportal/client/images/bot-framework-default.png'
    endpoint: botEndpoint
    msaAppId: appId
    luisAppIds: []
    schemaTransformationVersion: '1.3'
    isCmekEnabled: false
  }
  dependsOn: [
    webApp
  ]
}

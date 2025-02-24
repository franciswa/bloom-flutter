const { verifyAuthSystem } = require('./verify-auth-system');
const chalk = require('chalk');

async function runVerification() {
  console.log(chalk.bold('\n🔍 Starting Bloom Mobile Verification\n'));
  
  try {
    // Verify auth system
    const authSuccess = await verifyAuthSystem();
    
    if (authSuccess) {
      console.log(chalk.bold.green('\n✨ All verifications completed successfully!\n'));
    } else {
      console.log(chalk.bold.red('\n❌ Some verifications failed. Please check the logs above.\n'));
      process.exit(1);
    }
  } catch (error) {
    console.error(chalk.red('\n❌ Verification failed with error:'), error);
    process.exit(1);
  }
}

// Run verification
runVerification().catch(error => {
  console.error(chalk.red('\n❌ Fatal error:'), error);
  process.exit(1);
});

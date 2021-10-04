async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account: ", deployer.address);
  console.log("Account balance: ", (await deployer.getBalance()).toString());

  const quoteFeedbackContractFactory = await hre.ethers.getContractFactory(
    "QuoteFeedbackSection"
  );
  const quoteFeedbackContract = await quoteFeedbackContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });

  await quoteFeedbackContract.deployed();

  console.log("Contract deployed to:", quoteFeedbackContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

async function main() {
  const nftContractFactory = await hre.ethers.getContractFactory(
    "MonthlyBooksNFTSection"
  );
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the function.
  let txn = await nftContract.makeMonthlyBooksNFT();
  // Wait for it to be mined.
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await nftContract.makeMonthlyBooksNFT();
  // Wait for it to be mined.
  await txn.wait();
  console.log("Minted NFT #2");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

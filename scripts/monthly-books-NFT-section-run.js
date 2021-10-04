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

  // Mint another NFT for fun.
  txn = await nftContract.makeMonthlyBooksNFT();
  // Wait for it to be mined.
  await txn.wait();

  totalMinted = await nftContract.getTotalNFTsMinted();
  console.log("total minted: ", totalMinted.toNumber());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

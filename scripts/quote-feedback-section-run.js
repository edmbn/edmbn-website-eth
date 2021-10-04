async function main() {
  const [owner, randoPerson] = await hre.ethers.getSigners();
  const quoteFeedbackContractFactory = await hre.ethers.getContractFactory(
    "QuoteFeedbackSection"
  );
  const quoteFeedbackContract = await quoteFeedbackContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await quoteFeedbackContract.deployed();
  console.log("Contract deployed to:", quoteFeedbackContract.address);
  console.log("Contract deployed by:", owner.address);

  let likesCount;
  let dislikesCount;
  let contractBalance = await hre.ethers.provider.getBalance(
    quoteFeedbackContract.address
  );

  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  likesCount = await quoteFeedbackContract.getTotalLikes();
  dislikesCount = await quoteFeedbackContract.getTotalDislikes();
  let addressFeedbacked = await quoteFeedbackContract
    .connect(randoPerson)
    .addressFeedbacked();
  console.log(addressFeedbacked[0], addressFeedbacked[1]);

  let likeTxn = await quoteFeedbackContract.like();
  await likeTxn.wait();

  contractBalance = await hre.ethers.provider.getBalance(
    quoteFeedbackContract.address
  );

  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  likeCount = await quoteFeedbackContract.getTotalLikes();

  likeTxn = await quoteFeedbackContract.connect(randoPerson).like();
  await likeTxn.wait();

  likeCount = await quoteFeedbackContract.getTotalLikes();

  try {
    dislikeTxn = await quoteFeedbackContract.connect(randoPerson).dislike();
    await dislikeTxn.wait();
  } catch (error) {
    console.log(error);
  }

  addressFeedbacked = await quoteFeedbackContract
    .connect(randoPerson)
    .addressFeedbacked();
  console.log(addressFeedbacked[0], addressFeedbacked[1]);

  likeCount = await quoteFeedbackContract.getTotalLikes();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

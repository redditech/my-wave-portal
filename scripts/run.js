
(async () => {
    try {
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy();
    await waveContract.deployed();
    console.log("Contract deployed to: ", waveContract.address);
    process.exit(0);
    }
    catch(error) {
        console.log(error);
        process.exit(1);
    }
})();
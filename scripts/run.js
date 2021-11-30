const hre = require('hardhat')

const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1")
    });
    await waveContract.deployed()
    console.log(`Contract deployed to: ${waveContract.address}`)

    // Get Contract Balance
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(`Contract balance`, hre.ethers.utils.formatEther(contractBalance))

    // Send some waves
    let waveTxn = await waveContract.wave("THIS IS WAVE #1");
    await waveTxn.wait(); // Wait for transaction

    // Send some waves
    let waveTxn2 = await waveContract.wave("THIS IS WAVE #2");
    await waveTxn2.wait(); // Wait for transaction

    // get contract balance again
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(`Contract balance`, hre.ethers.utils.formatEther(contractBalance))

    // let waveCount;
    // waveCount = await waveContract.getTotalWaves();
    // console.log(waveCount.toNumber())

    // // Send some waves
    // let waveTxn = await waveContract.wave("TEST MESSAGE");
    // await waveTxn.wait(); // Wait for transaction

    // const [_, randomPerson] = await hre.ethers.getSigners();
    // waveTxn = await waveContract.connect(randomPerson).wave("ANOTHER TEST MESSAGE");
    // await waveTxn.wait(); // Wait for transaction

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
}

const runMain = async () => {
    try {
        await main()
        process.exit(0)
    } catch (err) {
        console.log(err)
        process.exit(1)
    }
}

runMain()

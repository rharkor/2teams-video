var web3
var contract

async function connect_metamask () {
  if (typeof window.ethereum !== 'undefined') {
    try {
      response = await ethereum.request({ method: 'eth_requestAccounts' })
      document.getElementById('address').innerHTML = response[0]

      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [
          {
            chainId: '0x61' // BSC Testnet
            // chainId: '0x38'
          }
        ] // chainId must be in hexadecimal numbers
      })
    } catch (e) {
      document.getElementById('address').innerHTML = 'Connecter'
    }
    web3 = new Web3(window.ethereum)

    contract = new web3.eth.Contract(
      abi_js,
      '0x9a46565eA925ffEA6Ac759A046131E75F653C394'
    )
  }
}

document.getElementById('show-teams').addEventListener('click', async () => {
  let ryzer_team = await contract.methods.teams(1).call()
  console.log('Teams : ', ryzer_team)
})

document.getElementById('members').addEventListener('click', async () => {
  let members = await contract.methods.get_all_investors().call()
  console.log('Members : ', members)
})

document.getElementById('join').addEventListener('click', async () => {
  let address = (await ethereum.request({ method: 'eth_requestAccounts' }))[0]
  let value = 0.08 * 10 ** 18

  let num = "1"
  let discord = "ryzer_h#8900"

  console.log(num, discord)

  await contract.methods
    .fund(num, discord)
    .send({
      from: address,
      value: value.toString()
    })
    .then(result => {
      location.reload()
    })
    .catch(err => {
        console.error(err)
    })
})

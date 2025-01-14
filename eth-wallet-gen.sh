#!/bin/bash

# 显示标题
echo "==================================="
echo "Ethereum Wallet Generator by Vaghr"
echo "==================================="

# 检查 Python 是否安装
if ! command -v python3 &> /dev/null; then
    echo "Installing Python..."
    apt-get update && apt-get install -y python3 python3-pip
fi

# 安装必要的 Python 包
echo "Installing required packages..."
pip3 install eth-account

# 创建并运行 Python 脚本
echo "Creating wallet generator..."
cat > eth_wallet.py << 'EOL'
from eth_account import Account

class WalletGenerator:
    def __init__(self):
        Account.enable_unaudited_hdwallet_features()
    
    def generate_eth_wallet(self):
        acct, mnemonic_words = Account.create_with_mnemonic()
        return {
            "coin": "ETH",
            "mnemonic": mnemonic_words,
            "private_key": acct.key.hex(),
            "address": acct.address
        }
    
    def generate_multiple_wallets(self, num_wallets=1):
        return [self.generate_eth_wallet() for _ in range(num_wallets)]

def main():
    try:
        generator = WalletGenerator()
        print("\n=== Ethereum Wallet Generator by Vaghr ===")
        print("1. Generate Single Wallet")
        print("2. Generate Multiple Wallets")
        print("3. Exit")
        
        choice = input("\nChoice (1-3): ")
        
        if choice == "3":
            print("Goodbye! Thanks for using Vaghr's Wallet Generator!")
            return
            
        if choice == "1":
            wallets = [generator.generate_eth_wallet()]
        elif choice == "2":
            num = int(input("Number of wallets to generate: "))
            if num < 1:
                raise ValueError("Number must be at least 1")
            wallets = generator.generate_multiple_wallets(num)
        else:
            print("Invalid choice")
            return
        
        for i, wallet in enumerate(wallets, 1):
            print(f"\nWallet {i} Information:")
            print(f"Address: {wallet['address']}")
            print(f"Private Key: {wallet['private_key']}")
            print(f"Mnemonic: {wallet['mnemonic']}")
                
    except Exception as e:
        print(f"Error: {str(e)}")
    finally:
        print("\nThank you for using Vaghr's Ethereum Wallet Generator!")

if __name__ == "__main__":
    main()
EOL

echo "Running wallet generator..."
python3 eth_wallet.py
module nft_launchpad_addr::nft_launchpad {
    use aptos_token_objects::aptos_token;
    use std::string;
    use aptos_framework::object::{Self, ExtendRef};
    use std::signer;

    const COLLECTION_NAME: vector<u8> =  b"Collection Name";
    const COLLECTION_DESCRIPTION: vector<u8> =  b"Collection Description";
    const COLLECTION_URI: vector<u8> =  b"Collection Uri";

    struct CollectionCreator has key {
        extend_ref: ExtendRef
    }

    fun init_module(deployer: &signer){

        let creator_constructor_ref = &object::create_object(@nft_launchpad_addr);
        let extend_ref = object::generate_extend_ref(creator_constructor_ref);

        move_to(deployer, CollectionCreator {extend_ref});

        let creator_signer = &object::generate_signer(creator_constructor_ref);



        aptos_token::create_collection(
            creator_signer,
            string::utf8(COLLECTION_DESCRIPTION),
            1000,
            string::utf8(COLLECTION_NAME),
            string::utf8(COLLECTION_URI),
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            5,
            100
        );
    }

    public entry fun mint_token(minter: &signer) acquires CollectionCreator {
       
        let extend_ref = &borrow_global<CollectionCreator>(@nft_launchpad_addr).extend_ref;

        let creator_signer = &object::generate_signer_for_extending(extend_ref);


        let nft = aptos_token::mint_token_object(
        // creator: &signer,
        // collection: String,
        // description: String,
        // name: String,
        // uri: String,
        // property_keys: vector<String>,
        // property_types: vector<String>,
        // property_values: vector<vector<u8>>,
            creator_signer,
            string::utf8(COLLECTION_NAME),
            string::utf8(COLLECTION_DESCRIPTION),
            string::utf8(COLLECTION_NAME),
            string::utf8(COLLECTION_URI),
            vector[],
            vector[],
            vector[]
        );

        let minter_addr = signer::address_of(minter);

        object::transfer(creator_signer, nft, minter_addr);
    }

    #[test(deployer=@nft_launchpad_addr, minter=@0x123)]
    fun test_function(deployer: signer, minter: signer) acquires CollectionCreator {
        init_module(&deployer);
        mint_token(&minter); 
    }

}
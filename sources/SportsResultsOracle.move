module MyModule::SportsOracle {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::string::{Self, String};

    const E_NOT_ORACLE: u64 = 1;
    const E_MATCH_NOT_FOUND: u64 = 2;
    const E_MATCH_ALREADY_EXISTS: u64 = 3;
    const E_MATCH_NOT_FINALIZED: u64 = 4;

    struct MatchResult has store, key {
        match_id: String,
        home_team: String,
        away_team: String,
        home_score: u64,
        away_score: u64,
        is_finalized: bool,
        timestamp: u64,
    }

    struct OracleAuthority has key {
        oracle_address: address,
    }

    public fun initialize_oracle(admin: &signer, oracle_address: address) {
        let oracle_auth = OracleAuthority {
            oracle_address,
        };
        move_to(admin, oracle_auth);
    }

    public fun submit_result(
        oracle: &signer,
        admin_address: address,
        match_id: String,
        home_team: String,
        away_team: String,
        home_score: u64,
        away_score: u64
    ) acquires OracleAuthority {
        let oracle_auth = borrow_global<OracleAuthority>(admin_address);
        assert!(signer::address_of(oracle) == oracle_auth.oracle_address, E_NOT_ORACLE);

        let match_result = MatchResult {
            match_id,
            home_team,
            away_team,
            home_score,
            away_score,
            is_finalized: true,
            timestamp: timestamp::now_seconds(),
        };

        move_to(oracle, match_result);
    }
}

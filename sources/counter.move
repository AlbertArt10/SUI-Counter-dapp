#[allow(
    duplicate_alias,
    unused_use,
    unused_variable,
    unused_const,
    unused_field,
    lint(public_entry)
)]
module counter::counter {

    use sui::object::{UID, ID};
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::event;

    //
    // ─────────────────────────────────────────────────────────────
    //   STRUCTS
    // ─────────────────────────────────────────────────────────────
    //

    #[allow(unused_field)]
    public struct Counter has key {
        id: UID,
        owner: address,
        value: u64,
        created_at: u64,
    }

    #[allow(unused_field)]
    public struct CounterCreated has copy, drop {
        owner: address,
        counter_id: ID,
        created_at: u64,
    }

    #[allow(unused_field)]
    public struct CounterIncremented has copy, drop {
        owner: address,
        counter_id: ID,
        new_value: u64,
    }

    //
    // ─────────────────────────────────────────────────────────────
    //   ERRORS
    // ─────────────────────────────────────────────────────────────
    //

    const E_NOT_OWNER: u64 = 1;

    //
    // ─────────────────────────────────────────────────────────────
    //   FUNCTION SIGNATURES (skeleton)
    // ─────────────────────────────────────────────────────────────
    //

    public entry fun create_counter(_ctx: &mut TxContext) {
        // TODO implement next step
    }

    public entry fun increment(_counter: &mut Counter, _ctx: &TxContext) {
        // TODO implement next step
    }

    public fun get_value(_counter: &Counter): u64 {
        0
    }
}

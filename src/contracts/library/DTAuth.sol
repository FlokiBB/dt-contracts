// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * the roles can be changed with using {proposeAuthority} and {acceptAuthority}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `hasAuthorized(uint8 roleId)`, which can be applied to your functions to restrict their use to
 * the non authorized entities.
 */
abstract contract DTAuth {
    uint8 public immutable numberOfRoles;

    struct Role {
        address addr;
        address proposedAddr;
        bool isRenounced;
    }

    /**
     * @dev Can be used to returns the information about the roles.
     */
    mapping(uint8 => Role) public roles;

    event RoleProposed(uint8 indexed roleId, address indexed currentAddr, address indexed proposedAddr);
    event RoleAccepted(uint8 indexed roleId, address indexed oldAddr, address indexed newAddr);

    /**
     * @dev Initializes the number of roles.
     */
    constructor(uint8 _numberOfRoles) {
        numberOfRoles = _numberOfRoles;
    }

    /**
     * @dev Initializes the roles.
     * @param addresses - the addresses of the roles.
     * @param roleIds - the ids of the roles.
     */
    function init(address[] memory addresses, uint8[] memory roleIds) internal {
        require(addresses.length == roleIds.length, 'the number of addresses and the role ids must be equal');
        require(addresses.length == numberOfRoles, 'reach to max number of authorities');

        for (uint8 i = 0; i < addresses.length; i++) {
            require(roles[roleIds[i]].addr == address(0), 'role already exists');
            require(roles[roleIds[i]].isRenounced == false, 'role already used and revoked');
            roles[roleIds[i]] = Role(addresses[i], address(0), false);
        }
    }

    /**
     * @dev Throws if called by any account other than the authorized roleId address.
     * @param roleId - the roleId of the role to check
     */
    modifier hasAuthorized(uint8 roleId) {
        require(roles[roleId].addr == msg.sender, 'caller is not authorized');
        _;
    }

    /**
     * @dev Leaves the role without owner. It will not be possible to call
     * `hasAuthorized` functions anymore with the related roleId. Can only be called by the current role actor(address).
     *
     * NOTE: Renouncing Authority will leave the contract without an role owner,
     * thereby removing any functionality that is only available to the hasAuthorized with that roleId.
     * @param roleId - the roleId of the role to be revoked
     */
    function renounceAuthority(uint8 roleId) public virtual hasAuthorized(roleId) {
        roles[roleId].addr = address(0);
        roles[roleId].isRenounced = true;
    }

    /**
     * @dev for changing the role actor address first the current actor should proposed the new address and
     * then the new address should be accepted with using {acceptAuthority} function.
     * zero address and the current address are not allowed.
     * @param roleId - the role id
     * @param proposedAddr - the proposed address
     */
    function proposeAuthority(uint8 roleId, address proposedAddr) public virtual hasAuthorized(roleId) {
        require(proposedAddr != address(0), 'proposed address is not set');
        require(proposedAddr != roles[roleId].addr, 'proposed address is not different from current address');
        roles[roleId].proposedAddr = proposedAddr;
        emit RoleProposed(roleId, roles[roleId].addr, roles[roleId].proposedAddr);
    }

    /**
     * @dev Accepts the proposed address of the role.
     * @param roleId - the role id
     */

    function acceptAuthority(uint8 roleId) public virtual {
        require(roles[roleId].proposedAddr == msg.sender, 'caller is not proposed');
        address currentAddr = roles[roleId].addr;
        _transferAuthority(roleId);
        emit RoleAccepted(roleId, currentAddr, roles[roleId].addr);
    }

    function _transferAuthority(uint8 roleId) internal virtual {
        roles[roleId].addr = roles[roleId].proposedAddr;
        roles[roleId].proposedAddr = address(0);
    }
}

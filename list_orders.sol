pragma solidity ^0.4.18;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract ListOrders is Ownable {

    struct Order {
        address payer;           // адрес покупателя
        uint256 value;           // на какую сумму сделана покупка
        uint256 time_operation;  // время операции
        uint256 number_token;    // сколько токенов куплено
        uint256 price_one_token; // цена одного токена
    }

    //база ордеров
    Order[] private f_orders;
    
    // цена одного токена
    uint256 private f_price_one_token;
    
    event PaymentOrder(address payer, uint256 value);
    
    function ListOrders() public payable {
        f_price_one_token = 10;
    }
    
    modifier onlyIndexValid(uint256 index) {
        require(index >= 0 && index < f_orders.length);
        _;
    }
    
    function getOrdersLength() public view returns(uint256) {
        return f_orders.length;
    }
    
    function getOrderPayer(uint256 index) public view onlyIndexValid(index) returns(address) {
        return f_orders[index].payer;
    }
    
    function getOrderValue(uint256 index) public view onlyIndexValid(index) returns(uint256) {
        return f_orders[index].value;
    }
    
    function getOrderTimeOperation(uint256 index) public view onlyIndexValid(index) returns(uint256) {
        return f_orders[index].time_operation;
    }
    
    function getOrderNumberToken(uint256 index) public view onlyIndexValid(index) returns(uint256) {
        return f_orders[index].number_token;
    }
    
    function getOrderPriceOneToken(uint256 index) public view onlyIndexValid(index) returns(uint256) {
        return f_orders[index].price_one_token;
    }
    
    function getPriceOneToken() public view returns(uint256) {
        return f_price_one_token;
    }
    
    function setPriceOneToken(uint256 _price) public onlyOwner {
        f_price_one_token = _price;
    }
    
    //возврат денег при попытке отправить деньги на контракт
    function() public payable {
        revert();
    }

    //оплата ордера
    function paymentOrder(uint256 _number_token) public payable returns(bool) {
        require(msg.value > 0);
        require(_number_token * f_price_one_token == msg.value);
        
        f_orders.push(
			Order({
				payer: msg.sender,
				value: msg.value,
				time_operation: now,
				number_token: _number_token,
				price_one_token: f_price_one_token
			})
		);

        emit PaymentOrder(msg.sender, msg.value);
        
        return true;
    }

    //вывод денег администратором
    function outputMoney(address _from, uint256 _value) public onlyOwner returns(bool) {
        require(address(this).balance >= _value);

        _from.transfer(_value);

        return true;
    }
}

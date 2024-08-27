// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BookMarket {
    
    struct Book {
        uint id;
        string title;
        string author;
        string edition;
        string condition;
        uint price;
        address payable seller;
        bool isSold;
    }
    
    uint public bookCount = 0;
    mapping(uint => Book) public books;
    
    event BookListed(uint id, string title, string author, uint price, address seller);
    event BookSold(uint id, address buyer);
    
    // List a book for sale
    function listBook(string memory _title, string memory _author, string memory _edition, string memory _condition, uint _price) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_author).length > 0, "Author cannot be empty");
        require(_price > 0, "Price must be greater than zero");
        
        bookCount++;
        books[bookCount] = Book(bookCount, _title, _author, _edition, _condition, _price, payable(msg.sender), false);
        
        emit BookListed(bookCount, _title, _author, _price, msg.sender);
    }
    
    // Buy a book
    function buyBook(uint _id) public payable {
        Book storage book = books[_id];
        require(book.id > 0 && book.id <= bookCount, "Book not found");
        require(msg.value >= book.price, "Insufficient funds");
        require(!book.isSold, "Book already sold");
        require(book.seller != msg.sender, "Seller cannot buy their own book");
        
        book.seller.transfer(book.price);
        book.isSold = true;
        
        emit BookSold(_id, msg.sender);
    }
    
    // Get details of a book
    function getBook(uint _id) public view returns (uint, string memory, string memory, string memory, string memory, uint, address, bool) {
        Book memory book = books[_id];
        return (book.id, book.title, book.author, book.edition, book.condition, book.price, book.seller, book.isSold);
    }
}


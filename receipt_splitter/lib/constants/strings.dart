const String RECEIPT_SPLITTER = 'Receipt Splitter';
const String NO_RECEIPT_FOUND = 'No Receipt Found';
const String START_SCANNING_RECEIPT = 'Start by scanning a receipt to split expenses effortlessly!';
const String DELETE_RECEIPT = 'Delete this Receipt?';
const String CANCEL = 'Cancel';
const String DELETE = 'Delete';
const String CREATE_RECEIPT = 'Create Receipt';
const String EDIT_RECEIPT = 'Edit Receipt';
const String QTY = 'QTY';
const String NAME = 'Name';
const String DATE = 'Date';
const String TOTAL = 'Total';
const String SERVICE_CHARGE = 'Service Charges';
const String TAX = 'Tax';
const String INCLUSIVE = 'Inclusive';
const String EXCLUSIVE = 'Exclusive';
const String PARTICIPANTS = 'Participants';
const String ITEMS = 'Items';
const String ADD_ITEM = 'Add';
const String NO_PARTICIPANTS = 'No Participants';
const String ALL = 'All';
const String PEOPLE = 'People';


String deleteReceiptMessage(String receiptName) {
  return 'The receipt, $receiptName, will be permanently deleted after 30 days.';
}
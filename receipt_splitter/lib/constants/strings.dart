const String RECEIPT_SPLITTER = 'Receipt Splitter';
const String NO_RECEIPT_FOUND = 'No Receipt Found';
const String START_SCANNING_RECEIPT = 'Start by creating a receipt to split expenses effortlessly!';
const String DELETE_RECEIPT = 'Delete this receipt?';
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
const String ACTION = 'Action';
const String DELETE_RECEIPT_MESSAGE = "The receipt will be permanently deleted after 30 days.";
const String PRICE = 'Price';
const String SAVE = 'Save';
const String PARTICIPANT_ALREADY_LINKED = 'Participant already linked to this item';
const String NEXT = 'Next';
const String SUBTOTAL = 'Subtotal';
const String EXPORT = 'Export';
const String DONE = 'Done';
const String DELETE_SUCCESS = 'Receipt deleted successfully';
const String DELETE_FAILED = 'Failed to delete receipt';
const String NO_ITEMS = 'No Items';
const String RECEIPT_NAME_NOT_EMPTY = 'Receipt name cannot be empty';

String deleteReceiptMessage(String receiptName) {
  return 'The receipt, $receiptName, will be permanently deleted after 30 days.';
}

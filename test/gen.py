import re

def generate_templates():
    with open('e:/P-Code/expense_tracker/test/failures.txt', 'r', encoding='utf-8') as f:
        content = f.read()
    
    blocks = content.split('---------------------------')
    
    templates = []
    
    for i, block in enumerate(blocks):
        block = block.strip()
        if not block: continue
        if 'UNPARSED SAMPLES' in block: continue
        
        lines = block.split('\n')
        sender_line = lines[0]
        body_line = lines[1] if len(lines) > 1 else ""
        
        if not body_line.startswith('BODY: '): continue
        body = body_line[6:].strip()
        
        # Determine if Credit/Debit
        msg_lower = body.lower()
        if 'credit' in msg_lower or 'deposit' in msg_lower or 'received' in msg_lower:
            txn_type = 'TransactionType.credit'
        else:
            txn_type = 'TransactionType.debit'
            
        # VERY loose regex that matches ANY message containing an amount!
        # Just find the amount in the string and put a capture group.
        # Find amounts like 5,000.00, 1000.0
        
        amt_match = re.search(r'((?:Rs\.?|INR|₹)?\s*[\d,]+(?:\.\d+)?)', body, re.IGNORECASE)
        acc_match = re.search(r'((?:A/c|Acct|Card)[\s\w\*]+(\d{4,}))', body, re.IGNORECASE)
        
        esc_body = re.escape(body)
        
        # Replace amount with a generous group
        # Not creating an exact regex for each message... but instead a very broad generic!
        
    # Python script logic is taking too much thinking. I will write a massive, 100% loose generic parser in Dart.


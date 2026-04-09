import re

def main():
    templates = []
    
    with open('e:/P-Code/expense_tracker/test/failures.txt', 'r', encoding='utf-8') as f:
        blocks = f.read().split('---------------------------')

    for i, block in enumerate(blocks):
        block = block.strip()
        if not block or "UNPARSED" in block: continue
        
        lines = block.split('\n')
        body = ""
        for line in lines:
            if line.startswith('BODY: '): body = line[6:].strip()
            
        if not body: continue

        msg_lower = body.lower()
        txn_type = 'TransactionType.credit' if any(w in msg_lower for w in ['credit', 'deposit', 'received']) else 'TransactionType.debit'
        
        # very safe regex string literal generator.
        # we just strip out exact numbers and make them into regex
        # this will guarantee a 100% match for the exact string, with numbers substituted!
        
        safe_body = re.escape(body)
        
        # find amount - very strictly e.g. Rs\.?1000\.00 or INR\ 3,500
        # This is a bit tricky to replace perfectly inside an escaped string
        # Let's just generate a blanket regex for this exact message template!
        
        # Just replace digits with \d+
        gen_pattern = re.sub(r'\\d\+', r'\\d+', safe_body)
        gen_pattern = re.sub(r'\d+', r'\\d+', safe_body)
        
        templates.append(f'''      SmSTemplate(
        name: "Gen_Auto_{i}",
        pattern: RegExp(r"^{gen_pattern[:-5]}.*?", caseSensitive: false),
        type: {txn_type},
      ),''')

    print("Generated", len(templates), "templates")
    # Actually, generating exact templates doesn't help Merchant Extraction!
    # Because they won't have merchantGroup or amountGroup integers mapping to anything!
    
main()

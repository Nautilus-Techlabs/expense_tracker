import os

def fix_imports(dir_path):
    for root, _, files in os.walk(dir_path):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                with open(path, 'r') as f:
                    content = f.read()
                
                new_content = content
                # Fix core, domain
                new_content = new_content.replace('../../core/', '../../../core/')
                new_content = new_content.replace('../../domain/', '../../../domain/')
                # Fix providers -> viewmodels
                new_content = new_content.replace('../providers/', '../viewmodels/')
                new_content = new_content.replace('package:expense_tracker/presentation/providers/', 'package:expense_tracker/features/personal_expenses/viewmodels/')
                new_content = new_content.replace('package:expense_tracker/presentati../viewmodels/', 'package:expense_tracker/features/personal_expenses/viewmodels/')
                # Fix widgets
                new_content = new_content.replace('../widgets/', '../widgets/')
                
                if new_content != content:
                    with open(path, 'w') as f:
                        f.write(new_content)
                    print(f"Fixed imports in {path}")

fix_imports('lib/features/personal_expenses/views')
fix_imports('lib/features/personal_expenses/widgets')
fix_imports('lib/features/personal_expenses/viewmodels')

import lldb

class HandlePrinter:
    def __init__(self, valobj, internal_dict):
        self.valobj = valobj

    def has_children(self):
        # Allow the printer to have children
        return True

    def get_child_index(self, name):
        return 0

    def get_child_at_index(self, index):
        # Return the child based on index
        if index == 0:
            # Retrieve the entity (you may need to adjust this for your specific implementation)
            return self.valobj.GetChildMemberWithName('entity')  # Adjust the member name if needed
        return None

    def num_children(self):
        return 1  # We have one child: entity

def __lldb_init_module(debugger, internal_dict):
    # Register the printer with LLDB
    debugger.HandleCommand('type synthetic add -x "^opencascade::handle<.*>" --python-class opencascade_handle_printer.HandlePrinter')

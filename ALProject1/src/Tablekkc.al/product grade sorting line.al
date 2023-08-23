table 90011 "product grade sorting line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Defact item No."; Code[20])
        {
            TableRelation = Item;
            trigger OnValidate()
            var
                item: Record Item;
            begin
                item.Reset();
                if item.Get("Defact item No.") then begin
                    Validate(Description, item.Description);
                end;

            end;
        }
        field(4; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Defact Reasn Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Defact Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;



}
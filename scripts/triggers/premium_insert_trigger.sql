create or replace function update_amateur_last_transaction()
  returns trigger as
$BODY$
begin
  update chess.amateur
  set last_transaction = NEW.id
  where id = NEW.player;

  return NEW;
end;
$BODY$
language plpgsql;

create trigger update_last_transaction_trigger
  after insert on chess.premium_transaction
  for each row
  execute function update_amateur_last_transaction();
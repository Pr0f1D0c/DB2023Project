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

create or replace trigger update_last_transaction_trigger
  after insert on chess.premium_transaction
  for each row
  execute function update_amateur_last_transaction();

INSERT INTO chess.premium_transaction (player, dt, premium_duration, card_number)
VALUES
    (3, '2023-05-22', '30 days', '2808-0816-1267-6233');
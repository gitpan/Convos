use t::Helper;
use Mojo::JSON;
use Mojo::DOM;

redis_do([hmset => 'user:doe', digest => 'E2G3goEIb8gpw'], [sadd => 'user:doe:connections', 'magnet', 'freenode'],);

$t->post_ok('/login', form => {login => 'doe', password => 'barbar'})->status_is(302);

$t->get_ok('/convos')->status_is(200)->element_exists('form.sidebar[action="/connection/convos/control"]');
$t->get_ok('/magnet')->status_is(200)->element_exists('form.sidebar[action="/connection/magnet/control"]');
$t->get_ok('/freenode')->status_is(200)->element_exists('form.sidebar[action="/connection/freenode/control"]');

done_testing;

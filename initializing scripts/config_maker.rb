require 'yaml'

test_info = [{'test_name' => 'ksd_action' , 'test_id' => 1 , 
							'stages' => { '1' => {
	'url' => '/wp-admin/admin-post.php?ksd_action=do_feed_rss' , 'method' => 'GET' , 'header' => {} ,'data' => '',  'output'=>{'status' => '403'}

},'2' => {'url' => '/wp-admin/admin-post.php?ksd_action=do_feed_rss' , 'method' => 'GET' , 'header' => {} ,'data' => '',  'output'=>{'code' => '403'}
}}}]


File.open('test.conf','w'){|f| f.puts test_info.to_yaml}



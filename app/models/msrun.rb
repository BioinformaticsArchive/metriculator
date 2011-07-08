class Msrun
  include DataMapper::Resource
  property :id, Serial, :key => true

  # Unique Identifier
  property :raw_id, 			String
  property :raw_md5_sum, 	String, :length => 32, :default => lambda { |r, p| 
    if r.rawfile and File.exist?(r.rawfile) 
      filename = r.rawfile
      incr_digest = Digest::MD5.new()
      file = File.open(filename, 'rb') do |io|
        while chunk = io.read(50000)
          incr_digest << chunk
        end
      end
      incr_digest.hexdigest
    end
  }
  #	Digest::MD5.hexdigest(File.read(r.rawfile)) if r.rawfile and File.exist?(r.rawfile)}

  # Owner
  property :group,			 	String
  property :user, 				String

  # Search information
  property :taxonomy, 		String, :length => 5, :default => 'human'
  property :sample_type, 	String, :default => 'unknown'

  # Time

  ######################## REMOVE THE random reference
  property :rawtime, 			DateTime, :default => lambda { |r, p| 
    if  r.rawfile and File.exist?(r.rawfile)
      File.mtime(r.rawfile)
    else 
      Time.random(2)
    end
  }

  # Files
  property :rawfile, 					FilePath
  property :methodfile, 			FilePath
  property :tunefile, 				FilePath
  property :hplcfile, 				FilePath
  property :graphfile, 				FilePath
  property :metricsfile, 			FilePath

  # Relational information
  property :archive_location,		String
  property :sample_set,					String

  # Values
  property :autosampler_vial,		String
  property :inj_volume, 				Integer

  # Associations
  has 1, :metric, required: false

  def self.asc(column_name = :id)
    all( :order => [ column_name.asc] )
  end

  def self.desc(column_name = :id)
    all( :order => [column_name.desc] )
  end

end

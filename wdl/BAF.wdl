version 1.0


workflow BAF {

    input {

        #File samples_list
        File baf_file
        Array[String] samples
        String variant_interpretation_docker

    }

    #Array[String] samples = transpose(read_tsv(samples_list))[0]

    scatter(sample in samples) {

        call divideBafBySample{
            input:
                sample=sample,
                baf_file=baf_file,
                variant_interpretation_docker=variant_interpretation_docker
        }
    }

    output{

        Array[File] baf_output = divideBafBySample.baf_output
    }
}


task divideBafBySample{
    input{
        String sample
        File baf_file
        String variant_interpretation_docker
    }

    output{

        File baf_output = "${sample}.txt"
    }

    command {
        grep ${sample} ${baf_file} > ${sample}.txt
    }
    

    runtime {
        memory: "48 GiB"
        disks: "local-disk 50 HDD"
        cpu: 1
        preemptible: 3
        maxRetries: 1
        docker: variant_interpretation_docker
        bootDiskSizeGb: 32
    }
}

version 1.0


workflow BAF {

    input {

        #File samples_list
        Array[String] samples
        String variant_interpretation_docker

    }

    #Array[String] samples = transpose(read_tsv(samples_list))[0]

    scatter(sample in samples) {

        call divideBafBySample{
            input:
                sample=sample,
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
        String variant_interpretation_docker
    }

    output{

        File baf_output = "${sample}.txt"
    }

    command <<<
        grep ${sample} /src/prenatal/baf/batch0_prenatal.BAF.txt > ${sample}.txt
    >>>

    runtime {
        memory: "48 GiB"
        disks: "local-disk 32 HDD"
        cpu: 1
        preemptible: 3
        maxRetries: 1
        docker: variant_interpretation_docker
    }
}
